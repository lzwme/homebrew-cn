class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https:joker-lang.org"
  url "https:github.comcandid82jokerarchiverefstagsv1.3.1.tar.gz"
  sha256 "52ddab431c7e8ebd3f3733679c55639fe99964c9ffba969042c537a3d0e809d9"
  license "EPL-1.0"
  head "https:github.comcandid82joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca73ed7b6f3a9925d707805b4f9f7494e7b15e96ab84800faac0db071029d965"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "627dd6a8aa42c0a67cdff2b97787933e96f11ed3e43055e6797115750de0256c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1fe8938fe94ceda503a60762e3a1bba521eb027991d2724cf79270725c3a2df"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b9f4c92136cff32fa511c61d3c50189467321003b7280330fbc7acce43e7877"
    sha256 cellar: :any_skip_relocation, ventura:        "768af0e58f2e450ba4a2f9bd4b3b8a74087d822fafed59711fceb4464ffd7094"
    sha256 cellar: :any_skip_relocation, monterey:       "92d684a9c1e3964ef154772848c183fe5d42b26b8fe153ca1ff6b62550048c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c2345de068d298678c55ace11a1cbe673fe5e4c12396ca1c44b33aa6f9b8e2a"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "...."
    system "go", "build", *std_go_args
  end

  test do
    test_file = testpath"test.clj"
    test_file.write <<~EOS
      (ns brewtest)
      (defn -main [& args]
        (let [a 1]))
    EOS

    system bin"joker", "--format", test_file
    output = shell_output("#{bin}joker --lint #{test_file} 2>&1", 1)
    assert_match "Parse warning: let form with empty body", output
    assert_match "Parse warning: unused binding: a", output

    assert_match version.to_s, shell_output("#{bin}joker -v 2>&1")
  end
end