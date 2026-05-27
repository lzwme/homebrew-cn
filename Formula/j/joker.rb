class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://ghfast.top/https://github.com/candid82/joker/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "a9fc641ff964854d575c5dd133c4a46825b509938b864c115df5b17b00221a80"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d790ab7dce14d777bfc685c74c1e529e05141d920676f5cb5b384d9565af30c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d790ab7dce14d777bfc685c74c1e529e05141d920676f5cb5b384d9565af30c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d790ab7dce14d777bfc685c74c1e529e05141d920676f5cb5b384d9565af30c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a5de14c0944e155d48730d33aa765de954e5484f1a33874c000a6afc21f5b9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "923605e8d1b9aa1ec50e2845cfae7314849848dce3137d85e5d9412cd406b6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d3bec238ed70f1431f8da9dbe53760e0babe38c037818b4513ac40a052ed7f2"
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