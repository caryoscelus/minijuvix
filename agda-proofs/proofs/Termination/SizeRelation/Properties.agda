module Termination.SizeRelation.Properties where

open import Base
open import Relation.Binary.PropositionalEquality.Properties as ≡
open import Termination.SizeRelation

open import Algebra.Structures {A = S} _≡_
open import Algebra.Definitions {A = S} _≡_
open import Algebra.Structures.StarSemiring {A = S} _≡_

-- Proofs on _+_

+-Commutative : Commutative _+_
+-Commutative ⁇ ⁇ = refl
+-Commutative ⁇ ≺ = refl
+-Commutative ⁇ ∼ = refl
+-Commutative ≺ ⁇ = refl
+-Commutative ≺ ≺ = refl
+-Commutative ≺ ∼ = refl
+-Commutative ∼ ⁇ = refl
+-Commutative ∼ ≺ = refl
+-Commutative ∼ ∼ = refl

+-Associative : Associative _+_
+-Associative ⁇ _ _ = refl
+-Associative ≺ _ _ = refl
+-Associative ∼ ⁇ _ = refl
+-Associative ∼ ≺ _ = refl
+-Associative ∼ ∼ ⁇ = refl
+-Associative ∼ ∼ ≺ = refl
+-Associative ∼ ∼ ∼ = refl

+-IsMagma : IsMagma _+_
+-IsMagma = record
  { isEquivalence = ≡.isEquivalence ;
  ∙-cong = λ { refl refl → refl }}

+-IsSemigroup : IsSemigroup _+_
+-IsSemigroup = record { isMagma = +-IsMagma ; assoc = +-Associative }

+-Identityˡ : LeftIdentity ⁇ _+_
+-Identityˡ _ = refl

+-Identityʳ : RightIdentity ⁇ _+_
+-Identityʳ ⁇ = refl
+-Identityʳ ≺ = refl
+-Identityʳ ∼ = refl

+-Identity : Identity ⁇ _+_
+-Identity = +-Identityˡ , +-Identityʳ

+-IsMonoid : IsMonoid _+_ ⁇
+-IsMonoid = record { isSemigroup = +-IsSemigroup ; identity = +-Identity }

+-IsCommutativeMonoid : IsCommutativeMonoid _+_ ⁇
+-IsCommutativeMonoid = record
  { isMonoid = +-IsMonoid ;
   comm = +-Commutative }

-- Proofs on _*_

*-Associative : Associative _*_
*-Associative ⁇ _ _ = refl
*-Associative ≺ ⁇ _ = refl
*-Associative ≺ ≺ ⁇ = refl
*-Associative ≺ ≺ ≺ = refl
*-Associative ≺ ≺ ∼ = refl
*-Associative ≺ ∼ _ = refl
*-Associative ∼ _ _ = refl

*-Commutative : Commutative _*_
*-Commutative ⁇ ⁇ = refl
*-Commutative ⁇ ≺ = refl
*-Commutative ⁇ ∼ = refl
*-Commutative ≺ ⁇ = refl
*-Commutative ≺ ≺ = refl
*-Commutative ≺ ∼ = refl
*-Commutative ∼ ⁇ = refl
*-Commutative ∼ ≺ = refl
*-Commutative ∼ ∼ = refl

*-Identityˡ : LeftIdentity ∼ _*_
*-Identityˡ _ = refl

*-Identityʳ : RightIdentity ∼ _*_
*-Identityʳ ⁇ = refl
*-Identityʳ ≺ = refl
*-Identityʳ ∼ = refl

*-Identity : Identity ∼ _*_
*-Identity = *-Identityˡ , *-Identityʳ

-- Proofs on + and *

*-DistributesOverˡ-+ : _*_ DistributesOverˡ _+_
*-DistributesOverˡ-+ ⁇ _ _ = refl
*-DistributesOverˡ-+ ≺ ⁇ _ = refl
*-DistributesOverˡ-+ ≺ ≺ _ = refl
*-DistributesOverˡ-+ ≺ ∼ ⁇ = refl
*-DistributesOverˡ-+ ≺ ∼ ≺ = refl
*-DistributesOverˡ-+ ≺ ∼ ∼ = refl
*-DistributesOverˡ-+ ∼ _ _ = refl

*-DistributesOverʳ-+ : _*_ DistributesOverʳ _+_
*-DistributesOverʳ-+ ⁇ ⁇ _ = refl
*-DistributesOverʳ-+ ⁇ ≺ ⁇ = refl
*-DistributesOverʳ-+ ⁇ ≺ ≺ = refl
*-DistributesOverʳ-+ ⁇ ≺ ∼ = refl
*-DistributesOverʳ-+ ⁇ ∼ ⁇ = refl
*-DistributesOverʳ-+ ⁇ ∼ ≺ = refl
*-DistributesOverʳ-+ ⁇ ∼ ∼ = refl
*-DistributesOverʳ-+ ≺ ⁇ _ = refl
*-DistributesOverʳ-+ ≺ ≺ _ = refl
*-DistributesOverʳ-+ ≺ ∼ ⁇ = refl
*-DistributesOverʳ-+ ≺ ∼ ≺ = refl
*-DistributesOverʳ-+ ≺ ∼ ∼ = refl
*-DistributesOverʳ-+ ∼ ⁇ _ = refl
*-DistributesOverʳ-+ ∼ ≺ _ = refl
*-DistributesOverʳ-+ ∼ ∼ ⁇ = refl
*-DistributesOverʳ-+ ∼ ∼ ≺ = refl
*-DistributesOverʳ-+ ∼ ∼ ∼ = refl

*-DistributesOver-+ : _*_ DistributesOver _+_
*-DistributesOver-+ = *-DistributesOverˡ-+ , *-DistributesOverʳ-+

*-IsMagma : IsMagma _*_
*-IsMagma = record
  { isEquivalence = ≡.isEquivalence
   ; ∙-cong = λ {refl refl → refl }}

*-IsSemigroup : IsSemigroup _*_
*-IsSemigroup = record { isMagma = *-IsMagma
  ; assoc = *-Associative }

*-IsMonoid : IsMonoid _*_ ∼
*-IsMonoid = record
   { isSemigroup = *-IsSemigroup
   ; identity = *-Identity }

+-*-IsSemiringWithoutAnnihilatingZero : IsSemiringWithoutAnnihilatingZero _+_ _*_ ⁇ ∼
+-*-IsSemiringWithoutAnnihilatingZero = record
  { +-isCommutativeMonoid = +-IsCommutativeMonoid
  ; *-isMonoid = *-IsMonoid
  ; distrib = *-DistributesOver-+
  }

*-LeftZero : LeftZero ⁇ _*_
*-LeftZero _ = refl

*-RightZero : RightZero ⁇ _*_
*-RightZero ⁇ = refl
*-RightZero ≺ = refl
*-RightZero ∼ = refl

*-Zero : Zero ⁇ _*_
*-Zero = *-LeftZero , *-RightZero

+-*-IsSemiring : IsSemiring _+_ _*_ ⁇ ∼
+-*-IsSemiring = record
  { isSemiringWithoutAnnihilatingZero = +-*-IsSemiringWithoutAnnihilatingZero
  ; zero = *-Zero }

+-*-IsCommutativeSemiring : IsCommutativeSemiring _+_ _*_ ⁇ ∼
+-*-IsCommutativeSemiring =
  record { isSemiring = +-*-IsSemiring
  ; *-comm = *-Commutative }

-- Proofs on ★
open ★1

★-condition-1 : (a : S) → ★ a ≡ ∼ + a * ★ a
★-condition-1 ⁇ = refl
★-condition-1 ≺ = refl
★-condition-1 ∼ = refl

★-condition-2 : (a : S) → ★ a ≡ ∼ + ★ a * a
★-condition-2 ⁇ = refl
★-condition-2 ≺ = refl
★-condition-2 ∼ = refl

+-*-★-IsStarSemiring : IsStarSemiring _+_ _*_ ★ ⁇ ∼
+-*-★-IsStarSemiring = record
   { isSemiring = +-*-IsSemiring
   ; ★-cond-1 = ★-condition-1
   ; ★-cond-2 = ★-condition-2 }