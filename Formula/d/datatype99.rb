class Datatype99 < Formula
  desc "Algebraic data types for C99"
  homepage "https:github.comHirrolotdatatype99"
  url "https:github.comHirrolotdatatype99archiverefstagsv1.6.4.tar.gz"
  sha256 "f8488decc7ab035e3af77ee62e64fc678d5cb57831457f7270efe003e63d6f09"
  license "MIT"
  head "https:github.comHirrolotdatatype99.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "76ee79a51c6ce2bda9aa261d0e6ef6d6883946b5b390224b2b70708eb0765234"
  end

  depends_on "metalang99"

  def install
    include.install "datatype99.h"
  end

  test do
    (testpath"test.c").write <<~C
      #include <datatype99.h>
      #include <stdio.h>

      datatype(
          BinaryTree,
          (Leaf, int),
          (Node, BinaryTree *, int, BinaryTree *)
      );

      int sum(const BinaryTree *tree) {
          match(*tree) {
              of(Leaf, x) return *x;
              of(Node, lhs, x, rhs) return sum(*lhs) + *x + sum(*rhs);
          }

          return -1;
      }

      #define TREE(tree)                ((BinaryTree *)(BinaryTree[]){tree})
      #define NODE(left, number, right) TREE(Node(left, number, right))
      #define LEAF(number)              TREE(Leaf(number))

      int main(void) {
          const BinaryTree *tree = NODE(NODE(LEAF(1), 2, NODE(LEAF(3), 4, LEAF(5))), 6, LEAF(7));
          printf("%d", sum(tree));
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["metalang99"].opt_include}", "-o", "test"
    assert_equal "28", shell_output(".test")
  end
end