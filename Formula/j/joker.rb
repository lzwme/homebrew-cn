class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://ghfast.top/https://github.com/candid82/joker/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f7d48c503feed4ee8e2680febad07ba0cdbb7dae5886e119261163c27cf28899"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc47036c071febb64e02fa40e3c4ca4c6486bbb3fb53331ca7b8400fdd1612bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc47036c071febb64e02fa40e3c4ca4c6486bbb3fb53331ca7b8400fdd1612bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc47036c071febb64e02fa40e3c4ca4c6486bbb3fb53331ca7b8400fdd1612bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5920f537a6f6eeba80366fdf1bd13b5daa0edaa7df52d92c96dbfe021312e4cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0a957da227f5f48d2bebe67e620d042f6f2edd7cb263f6b323c41f230a918cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e994c025ba4233607f9cd1e0c7062ad035b591dadea76a84a7c3e293a21a7b20"
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