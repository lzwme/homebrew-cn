class GoPassboltCli < Formula
  desc "CLI for passbolt"
  homepage "https://www.passbolt.com/"
  url "https://ghfast.top/https://github.com/passbolt/go-passbolt-cli/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "009042a200146ddb1c8c2ed20084efb1fc65047219ef21a21d6c490af228f0cf"
  license "MIT"
  head "https://github.com/passbolt/go-passbolt-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14e9808152ed1f3941e4f14a110baff96b7e26879665c648c535beeb9945eb63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14e9808152ed1f3941e4f14a110baff96b7e26879665c648c535beeb9945eb63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14e9808152ed1f3941e4f14a110baff96b7e26879665c648c535beeb9945eb63"
    sha256 cellar: :any_skip_relocation, sonoma:        "caf55984584c233354224e64e05c200645a5ea239d1f9483734723ec411c0722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80e6bc77a95a6be81d6d87fbad3baecec97ff27740c544376935f1168308a5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfeb7c80de07ed39e3bcbb8e7eb192c7dfb976c7c52a8b93fe0f025191d0f2a8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"passbolt")

    generate_completions_from_executable(bin/"passbolt", "completion")
    mkdir "man"
    system bin/"passbolt", "gendoc", "--type", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/passbolt --version")
    assert_match "Error: serverAddress is not defined", shell_output("#{bin}/passbolt list user 2>&1", 1)
  end
end