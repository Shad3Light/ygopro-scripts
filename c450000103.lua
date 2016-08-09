--獄炎
function c450000103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCost(c450000103.cost)
	e1:SetCondition(c450000103.condition)
	e1:SetTarget(c450000103.target)
	e1:SetOperation(c450000103.activate)
	c:RegisterEffect(e1)
end
function c450000103.costfilter(c)
	return c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c450000103.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c450000103.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c450000103.costfilter,1,1,REASON_COST)
end
function c450000103.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c450000103.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	local dam=tg:GetAttack()
	Duel.SetTargetParam(dam/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam/2)
end
function c450000103.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg,d=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PARAM)
	local tc=tg:GetFirst()
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		if Duel.Destroy(tc,REASON_EFFECT) then
			Duel.Damage(1-tp,d,REASON_EFFECT)
		end
	end
end
