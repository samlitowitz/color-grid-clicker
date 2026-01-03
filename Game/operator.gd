class_name Operator extends Resource

enum OperType {
	ADD,
	MULT,
}

var _type: OperType = OperType.ADD

func with_type(type: OperType) -> Operator:
	self._type = type
	return self
