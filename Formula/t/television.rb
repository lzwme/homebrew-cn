class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.6.2.tar.gz"
  sha256 "79ad4464928812de3a6672c1dba100bf327f90fd7900eed2d0c24a9cdae047f8"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7019c436f26b2fec4c9f3505562cae0838c8bc1614779be62fd5dadf7bedd821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4020576a465344ee06a71c0862e6510705426e08b3787ea1b39c272b7f1dc83c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf9d4971adbeb803b35043a8a90214cd9bbfdf48eef18a2374897a3cc3a6d52f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c0c16af7b2b1a32cc12c798304822cf20a483861acff425f591463e90f57530"
    sha256 cellar: :any_skip_relocation, ventura:       "a4cdf54927d1a31802084280e2da9389dc469039a8d52555d2bfd6c730597f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf70ae0c7d3a536a62745c6dbaaa6dee7ba0774bf16acd0d9397cdb5747ba7f"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath"output.log"
      pid = spawn bin"tv", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Preview", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end