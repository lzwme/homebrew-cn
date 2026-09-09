class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.18.3/pup_1.18.3_source.tar.gz"
  sha256 "b2c9274436bae687724011f614b3691709f2c0e8d711e94baeac42d3213b517f"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74301d135234760e239c795ca93d2335b3a587c34d1acd9bcdb25d78caf458e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ed821aafa22df78d5be3e4b5d1a7eb51c945092b8c975b9441bca507132d0a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14d18cb8013e737d9bf88d9aad79ea8afde3dd373a0ad98c578cbae07a27c2c6"
    sha256 cellar: :any,                 arm64_linux:   "0eaa0f18460df65dd68079e1f90b5c07c8d29ae5ab179de822b610301861e694"
    sha256 cellar: :any,                 x86_64_linux:  "fedad2e3b95ccda47b6abdcac8d7852afe5abedcbd249de4c23a9c4990e3e99b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end