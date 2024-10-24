class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.17.10.tar.gz"
  sha256 "96a0c9cbec38efab5501b1e8434c91c3822a53bbdcf8cb2c2ba50cda791f383b"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70cca2c85aa1a5aa29c835074af4b4891e2126e507246aaa7019bb9badd66582"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4779290698a65f13f2c18ec4e8fa2d54224f9d588c027b3578d5c43926ac7907"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eee1cb837f49c6ed5b853f6de107475815a036da5fb914e39f411727df7c864f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f19235a683b11d53b338e2e389137c0fbefec28fbb3d7852b71e4a70633d2177"
    sha256 cellar: :any_skip_relocation, ventura:       "ff43063bc3edecb3a605023108aadb231fe05eeb94db563c599caf5f9e255508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "096fe613b3c6bbf5eac779e92b371e0c3c1001666325647c75bb900a7da7e5c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end