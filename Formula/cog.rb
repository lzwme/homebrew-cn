class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://ghproxy.com/https://github.com/replicate/cog/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "d143f50bf601f04cbeca0693e436eeb9e7c706c6423a5e4647dba480a2ecd3d2"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4df17026bc65752a0724099864cc5dfbcd15319864c967441a9da3798b0a71e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4884f2b8c6ef1bf15f306da34454238fdfaa0f84d1ff082184bfa912b0a0497e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c84a6a8a8815387ca23492d1b3ed91cb4ac4727edea9f885e647857590d6b47c"
    sha256 cellar: :any_skip_relocation, ventura:        "974ece522cea48888170850e64e169d8ca8ea3a25e72163a30b3e557b7f2fd78"
    sha256 cellar: :any_skip_relocation, monterey:       "c78e612de61d55aca423cbca159ae186aa9089c01a8c1ce7c2fce067faae9780"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b5265e75ad706db28f4de46e4b1346ddebf83547c3c57f8dec8ce2dbdc10ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3035fc5efefec7024a2d3eeff9d167f54e7e1a5adcade461614a1ecc8a72dee1"
  end

  depends_on "go" => :build
  depends_on "redis"

  uses_from_macos "python" => :build

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    system "make", "COG_VERSION=#{version}", "PYTHON=python3"
    bin.install "cog"
    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end