class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "e8642679a987ff6483ff600cfbf1d7d52b2975527f242f0052ef756f59af0306"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34f8fc1b4fb1ff08fda74edb94576eba3cb7e6609cc63da517cf4b964cb52997"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34f8fc1b4fb1ff08fda74edb94576eba3cb7e6609cc63da517cf4b964cb52997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34f8fc1b4fb1ff08fda74edb94576eba3cb7e6609cc63da517cf4b964cb52997"
    sha256 cellar: :any_skip_relocation, sonoma:        "32190e376069fb3775c43b6c767b49c0f0ef107b1fbd674cd663bbe175f5c7c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a5b041a3eb1563346e5920ce88116a38365e214e948d489de6549fa281f210c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d46f5283525a5de371b181ddb241153ef0342a7f67a6580407985d2f98c011bb"
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