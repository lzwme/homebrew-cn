class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "0b2b7191b767d68a8b631fb9e567d87ba3fc361fc7dd68cef5694e26e5a03795"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7e132ac0a9e569b4d2bdd78ec269901ddbe00c98eaec9d4e77a0d05140b5bd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7e132ac0a9e569b4d2bdd78ec269901ddbe00c98eaec9d4e77a0d05140b5bd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7e132ac0a9e569b4d2bdd78ec269901ddbe00c98eaec9d4e77a0d05140b5bd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc7e4b641abaea6b41f0b2edd8175280f985ccd45a422f1b21d76c498c5a7881"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "537241b5feac42e8969f6dd99327e0ec13f4a3236fff57b1a5eb5d0c519d64cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6c617e1ffa4f35e10577fc6ccb03bea475d50fe5163211b78d6f1083c2625ea"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end