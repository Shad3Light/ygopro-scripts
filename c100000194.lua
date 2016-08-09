--ダイス・クライシス
function c100000194.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)	
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)	
	e1:SetCondition(c100000194.condition)
	e1:SetTarget(c100000194.target)
	e1:SetOperation(c100000194.operation)
	c:RegisterEffect(e1)
end
function c100000194.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c100000194.filter(c,tc)
	return c:IsControlerCanBeChanged()
end
function c100000194.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c100000194.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c100000194.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and eg:IsContains(tc)
end
function c100000194.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c100000194.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	return tc
end
function c100000194.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.GetControl(tc,tc:GetOwner())
	end
end
function c100000194.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()	
	if d==6 then 
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and c:IsLocation(LOCATION_SZONE) 
			and not tc:IsImmuneToEffect(e) then
				Duel.Equip(tp,c,tc)
				--Add Equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(c100000194.eqlimit)
				e1:SetLabelObject(tc)
				c:RegisterEffect(e1)
				--destroy
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e2:SetRange(LOCATION_SZONE)
				e2:SetCode(EVENT_LEAVE_FIELD)	
				e2:SetCondition(c100000194.descon)
				e2:SetOperation(c100000194.desop)				
				e2:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e2)
				--Control
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_EQUIP)
				e3:SetCode(EFFECT_SET_CONTROL)
				e3:SetValue(tp)
				e3:SetReset(RESET_EVENT+0x1fc0000)
				c:RegisterEffect(e3)
				--cannot attack
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_EQUIP)
				e4:SetCode(EFFECT_SET_ATTACK)
				e4:SetValue(0)				
				e4:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e4)
		end
	end
end