import ..u_semiring
import ..sql
import ..tactics

open SQL
open Proj
open Expr

lemma commutativeSelect:
 forall Γ s a slct0 slct1,
    denoteSQL ((SELECT * FROM1 (SELECT * FROM1 a WHERE slct1) WHERE slct0): SQL Γ s) =
    denoteSQL ((SELECT * FROM1 (SELECT * FROM1 a WHERE slct0) WHERE slct1): SQL Γ s) :=
begin
    intros,
    unfold_all_denotations,
    funext,
    -- simp should work here, but it seems require ac refl now 
    ac_refl,
end

lemma pushdownSelect:
    forall Γ s1 s2 (r: SQL Γ s1) (s: SQL Γ s2) slct,
    denoteSQL 
    ((SELECT * FROM1 (SQL.product r (SELECT * FROM1 s WHERE slct))) : SQL Γ _) =
    denoteSQL 
    (SELECT * 
    FROM1 (SQL.product r s) 
    WHERE (Pred.castPred (Proj.combine left (right⋅right)) slct): SQL Γ _) :=
begin
    intros,
    unfold_all_denotations,
    funext,
    ac_refl
end

lemma disjointSelect:
    forall Γ s (a: SQL Γ s) slct0 slct1,
    denoteSQL ((DISTINCT SELECT * FROM1 a WHERE (slct0 OR slct1)): SQL Γ _) =
    denoteSQL ((DISTINCT ((SELECT * FROM1 a WHERE slct0) UNION ALL (SELECT * FROM1 a WHERE slct1))) : SQL Γ _) :=
begin
    intros,
    unfold_all_denotations,
    funext,    
    simp,
end