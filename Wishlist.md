# Tick — Wishlist

Ideas para futuras evoluciones de la librería.

---

## ViewModel-driven validation (result builder)

**Problema:** El approach actual (modifier + PreferenceKey) depende del view tree. Si un campo no está visible (List/Form con reciclado), no se valida.

**Propuesta:** Declarar reglas en el ViewModel con un result builder, ejecutar validación independientemente del render.

```swift
@Observable class AddressViewModel {
    var address = AddressDto()
    var errors: [PartialKeyPath<AddressDto>: String] = [:]

    func validate() -> Bool {
        errors = Tick.validate(address) {
            \.country    => [.required]
            \.postalCode => [.required, .postalCode(.es, province: address.province)]
            \.province   => [.required]
        }
        return errors.isEmpty
    }
}
```

**Decisiones abiertas:**
- Cómo resetear errores al editar un campo
- Cómo expresar validaciones condicionales con keypaths
- Cómo manejar structs anidados
- Compatibilidad con el approach actual de modifier (migración gradual o coexistencia)

---

## Teléfono por país

Validar formato de móvil según el país seleccionado (ES: 9 dígitos, PT: 9, FR: 10, IT: 10) con prefijos válidos.

---

## Validación en tiempo real (live mode)

Permitir que ciertos campos validen mientras el usuario escribe (no solo on blur). Útil para contraseñas con checklist de requisitos. Esto es responsabilidad de quien consume Tick, no de la librería en sí, pero documentar un patrón recomendado ayudaría.
