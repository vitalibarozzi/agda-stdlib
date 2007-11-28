------------------------------------------------------------------------
-- Lexicographic products of binary relations
------------------------------------------------------------------------

-- The definition here is suitable if the left-hand relation is a
-- partial order.

module Relation.Binary.Product.NonstrictLex where

open import Data.Product
open import Data.Sum
open import Relation.Binary
open import Relation.Binary.Consequences
import Relation.Binary.NonstrictToStrict as Conv
import Relation.Binary.Product.PointWise as PointWise
open PointWise using (_×-Rel_)
import Relation.Binary.Product.StrictLex as Strict

private
 module Dummy {a₁ a₂ : Set} where

  ×-Lex : (≈₁ ≤₁ : Rel a₁) -> (≤₂ : Rel a₂) -> Rel (a₁ × a₂)
  ×-Lex ≈₁ ≤₁ ≤₂ = Strict.×-Lex ≈₁ (Conv._<_ ≈₁ ≤₁) ≤₂

  -- Some properties which are preserved by ×-Lex (under certain
  -- assumptions).

  abstract

    ×-reflexive
      :  forall ≈₁ ≤₁ {≈₂} ≤₂
      -> Reflexive ≈₂ ≤₂ -> Reflexive (≈₁ ×-Rel ≈₂) (×-Lex ≈₁ ≤₁ ≤₂)
    ×-reflexive ≈₁ ≤₁ ≤₂ refl₂ {x} {y} =
      Strict.×-reflexive ≈₁ (Conv._<_ ≈₁ ≤₁) ≤₂ refl₂ {x} {y}

    ×-transitive
      :  forall {≈₁ ≤₁} -> IsPartialOrder ≈₁ ≤₁
      -> forall {≤₂} -> Transitive ≤₂
      -> Transitive (×-Lex ≈₁ ≤₁ ≤₂)
    ×-transitive {≈₁ = ≈₁} {≤₁ = ≤₁} po₁ {≤₂ = ≤₂} trans₂
                 {x} {y} {z} =
      Strict.×-transitive
        {<₁ = Conv._<_ ≈₁ ≤₁}
        isEquivalence (Conv.≈-resp-< _ _ isEquivalence ≈-resp-≤)
        (Conv.<-trans _ _ po₁)
        {≤₂ = ≤₂} trans₂ {x} {y} {z}
      where
      open module PO = IsPartialOrderOps po₁

    ×-antisymmetric
      :  forall {≈₁ ≤₁} -> IsPartialOrder ≈₁ ≤₁
      -> forall {≈₂ ≤₂} -> Antisymmetric ≈₂ ≤₂
      -> Antisymmetric (≈₁ ×-Rel ≈₂) (×-Lex ≈₁ ≤₁ ≤₂)
    ×-antisymmetric {≈₁ = ≈₁} {≤₁ = ≤₁} po₁ {≤₂ = ≤₂} antisym₂
                    {x} {y} =
      Strict.×-antisymmetric {<₁ = Conv._<_ ≈₁ ≤₁} ≈-sym₁ irrefl₁ asym₁
                             {≤₂ = ≤₂} antisym₂ {x} {y}
      where
      open module PO = IsPartialOrderOps po₁
      open module E  = Eq renaming (refl to ≈-refl₁; sym to ≈-sym₁)

      irrefl₁ : Irreflexive ≈₁ (Conv._<_ ≈₁ ≤₁)
      irrefl₁ = Conv.<-irrefl ≈₁ ≤₁

      asym₁ : Asymmetric (Conv._<_ ≈₁ ≤₁)
      asym₁ = trans∧irr⟶asym ≈-refl₁ (Conv.<-trans _ _ po₁) irrefl₁

    ×-≈-respects₂
      :  forall {≈₁ ≤₁} -> IsEquivalence ≈₁ -> ≈₁ Respects₂ ≤₁
      -> forall {≈₂ ≤₂} -> ≈₂ Respects₂ ≤₂
      -> (≈₁ ×-Rel ≈₂) Respects₂ (×-Lex ≈₁ ≤₁ ≤₂)
    ×-≈-respects₂ eq₁ resp₁ resp₂ =
      Strict.×-≈-respects₂ eq₁ (Conv.≈-resp-< _ _ eq₁ resp₁) resp₂

    ×-decidable
      :  forall {≈₁ ≤₁} -> Decidable ≈₁ -> Decidable ≤₁
      -> forall {≤₂} -> Decidable ≤₂
      -> Decidable (×-Lex ≈₁ ≤₁ ≤₂)
    ×-decidable dec-≈₁ dec-≤₁ dec-≤₂ =
      Strict.×-decidable dec-≈₁ (Conv.<-decidable _ _ dec-≈₁ dec-≤₁)
                         dec-≤₂

    ×-total
      :  forall {≈₁ ≤₁}
      -> Symmetric ≈₁ -> Decidable ≈₁
      -> Antisymmetric ≈₁ ≤₁ -> Total ≤₁
      -> forall {≤₂} -> Total ≤₂
      -> Total (×-Lex ≈₁ ≤₁ ≤₂)
    ×-total {≈₁ = ≈₁} {≤₁ = ≤₁} sym₁ dec₁ antisym₁ total₁
                      {≤₂ = ≤₂} total₂ = total
      where
      tri₁ : Trichotomous ≈₁ (Conv._<_ ≈₁ ≤₁)
      tri₁ = Conv.<-trichotomous _ _ sym₁ dec₁ antisym₁ total₁

      total : Total (×-Lex ≈₁ ≤₁ ≤₂)
      total x y with tri₁ (proj₁ x) (proj₁ y)
      ... | Tri₁ x₁<y₁ x₁≉y₁ x₁≯y₁ = inj₁ (inj₁ x₁<y₁)
      ... | Tri₃ x₁≮y₁ x₁≉y₁ x₁>y₁ = inj₂ (inj₁ x₁>y₁)
      ... | Tri₂ x₁≮y₁ x₁≈y₁ x₁≯y₁ with total₂ (proj₂ x) (proj₂ y)
      ...   | inj₁ x₂≤y₂ = inj₁ (inj₂ (x₁≈y₁ , x₂≤y₂))
      ...   | inj₂ x₂≥y₂ = inj₂ (inj₂ (sym₁ x₁≈y₁ , x₂≥y₂))

  -- Some collections of properties which are preserved by ×-Lex
  -- (under certain assumptions).

  abstract

    _×-isPartialOrder_
      :  forall {≈₁ ≤₁} -> IsPartialOrder ≈₁ ≤₁
      -> forall {≈₂ ≤₂} -> IsPartialOrder ≈₂ ≤₂
      -> IsPartialOrder (≈₁ ×-Rel ≈₂) (×-Lex ≈₁ ≤₁ ≤₂)
    _×-isPartialOrder_ {≈₁ = ≈₁} {≤₁ = ≤₁} po₁ {≤₂ = ≤₂} po₂ = record
      { isPreorder = record
          { isEquivalence = PointWise._×-isEquivalence_
                              (isEquivalence po₁)
                              (isEquivalence po₂)
          ; refl          = \{x y} ->
                            ×-reflexive ≈₁ ≤₁ ≤₂ (refl po₂) {x} {y}
          ; trans         = \{x y z} ->
                            ×-transitive po₁ {≤₂ = ≤₂} (trans po₂)
                                         {x} {y} {z}
          ; ≈-resp-∼      = ×-≈-respects₂ (isEquivalence po₁)
                                          (≈-resp-≤ po₁)
                                          (≈-resp-≤ po₂)
          }
      ; antisym = \{x y} ->
                  ×-antisymmetric {≤₁ = ≤₁} po₁
                                  {≤₂ = ≤₂} (antisym po₂) {x} {y}
      }
      where open IsPartialOrderOps

    ×-isTotalOrder
      :  forall {≈₁ ≤₁} -> Decidable ≈₁ -> IsTotalOrder ≈₁ ≤₁
      -> forall {≈₂ ≤₂} -> IsTotalOrder ≈₂ ≤₂
      -> IsTotalOrder (≈₁ ×-Rel ≈₂) (×-Lex ≈₁ ≤₁ ≤₂)
    ×-isTotalOrder {≤₁ = ≤₁} ≈₁-dec to₁ {≤₂ = ≤₂} to₂ = record
      { isPartialOrder = isPartialOrder to₁ ×-isPartialOrder
                         isPartialOrder to₂
      ; total          = ×-total {≤₁ = ≤₁} (Eq.sym to₁) ≈₁-dec
                                           (antisym to₁) (total to₁)
                                 {≤₂ = ≤₂} (total to₂)
      }
      where open IsTotalOrderOps

    _×-isDecTotalOrder_
      :  forall {≈₁ ≤₁} -> IsDecTotalOrder ≈₁ ≤₁
      -> forall {≈₂ ≤₂} -> IsDecTotalOrder ≈₂ ≤₂
      -> IsDecTotalOrder (≈₁ ×-Rel ≈₂) (×-Lex ≈₁ ≤₁ ≤₂)
    _×-isDecTotalOrder_ {≤₁ = ≤₁} to₁ {≤₂ = ≤₂} to₂ = record
      { isTotalOrder = ×-isTotalOrder (_≟_ to₁)
                                      (isTotalOrder to₁)
                                      (isTotalOrder to₂)
      ; ≈-decidable  = PointWise._×-decidable_ (_≟_ to₁) (_≟_ to₂)
      ; ≤-decidable  = ×-decidable (_≟_ to₁) (_≤?_ to₁) (_≤?_ to₂)
      }
      where open IsDecTotalOrderOps

open Dummy public

-- "Packages" (e.g. posets) can also be combined.

_×-poset_ : Poset -> Poset -> Poset
p₁ ×-poset p₂ = record
  { carrier        = carrier p₁ ×     carrier p₂
  ; underlyingEq   = _≈_     p₁ ×-Rel _≈_     p₂
  ; order          = ×-Lex (_≈_ p₁) (_≤_ p₁) (_≤_ p₂)
  ; isPartialOrder = isPartialOrder p₁ ×-isPartialOrder
                     isPartialOrder p₂
  }
  where open PosetOps

_×-totalOrder_ : DecTotalOrder -> TotalOrder -> TotalOrder
t₁ ×-totalOrder t₂ = record
  { carrier      = T₁.carrier ×     T₂.carrier
  ; underlyingEq = T₁._≈_     ×-Rel T₂._≈_
  ; order        = ×-Lex T₁._≈_ T₁._≤_ T₂._≤_
  ; isTotalOrder = ×-isTotalOrder T₁._≟_ T₁.isTotalOrder T₂.isTotalOrder
  }
  where
  module T₁ = DecTotalOrderOps t₁
  module T₂ =    TotalOrderOps t₂

_×-decTotalOrder_ : DecTotalOrder -> DecTotalOrder -> DecTotalOrder
t₁ ×-decTotalOrder t₂ = record
  { carrier         = carrier t₁ ×     carrier t₂
  ; underlyingEq    = _≈_     t₁ ×-Rel _≈_     t₂
  ; order           = ×-Lex (_≈_ t₁) (_≤_ t₁) (_≤_ t₂)
  ; isDecTotalOrder = isDecTotalOrder t₁ ×-isDecTotalOrder
                      isDecTotalOrder t₂
  }
  where open DecTotalOrderOps
