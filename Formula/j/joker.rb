class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://ghfast.top/https://github.com/candid82/joker/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "51281b77741f61cc8fbe8f11b9c6da49cadebc66565f9be91f71530d562db441"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45d58f6caa4f90cd93fa2ed4c7348ad034bef1405e2f24e52b825b1a1399d7df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45d58f6caa4f90cd93fa2ed4c7348ad034bef1405e2f24e52b825b1a1399d7df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45d58f6caa4f90cd93fa2ed4c7348ad034bef1405e2f24e52b825b1a1399d7df"
    sha256 cellar: :any_skip_relocation, sonoma:        "6605ea1715b6fc19f8d87eb07626dab89a5843b1155fd388fa85786363008db9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdef96748284b3e1ba5049dc22b2ec44043213895e339f58abbe1c80f022b09f"
    sha256 cellar: :any,                 x86_64_linux:  "78e1ccfe1e28b5b71e177f24439879262807e7b90aa58481f04addd05ab6ee57"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args
  end

  test do
    test_file = testpath/"test.clj"
    test_file.write <<~CLOJURE
      (ns brewtest)
      (defn -main [& args]
        (let [a 1]))
    CLOJURE

    system bin/"joker", "--format", test_file
    output = shell_output("#{bin}/joker --lint #{test_file} 2>&1", 1)
    assert_match "Parse warning: let form with empty body", output
    assert_match "Parse warning: unused binding: a", output

    assert_match version.to_s, shell_output("#{bin}/joker -v 2>&1")
  end
end