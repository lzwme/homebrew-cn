class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.75.6.tar.gz"
  sha256 "de9a8b32bda40ad9f2a1043d7984f596fe957f1483de124b76b5f089fccc1202"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e26c68b79b64140e9db9663b788a24de211aa53cc2285b077a1f654c621f3c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e26c68b79b64140e9db9663b788a24de211aa53cc2285b077a1f654c621f3c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e26c68b79b64140e9db9663b788a24de211aa53cc2285b077a1f654c621f3c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c47f04ef65421dbce7b5e71428ca750f31e8660b4f8cca10b2cb82556b067ede"
    sha256 cellar: :any_skip_relocation, ventura:       "c47f04ef65421dbce7b5e71428ca750f31e8660b4f8cca10b2cb82556b067ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449777ef4316555e14783cf4135627d1e5edcee0f1533aca01d289116472dc0d"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end