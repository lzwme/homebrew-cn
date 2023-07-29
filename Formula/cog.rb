class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://ghproxy.com/https://github.com/replicate/cog/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "89612a62c943d0bd9d04df35f7b29237b35d57c874c1e8045d2fbc680e6fd162"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28a5877568cbf211db72629ae445838bef313ca59e150a93e6e99e6a79968daf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0576af36104579a7acbe29b3839906f93618f35fcdd270af629dd34512cd79b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "302542f74497493d1bf75317395e09ffff7ecf0be73008185a897551e4c204d6"
    sha256 cellar: :any_skip_relocation, ventura:        "79b8a2efe66989aa891d43091168bded66c622e82da68f7d39295b6448d37abe"
    sha256 cellar: :any_skip_relocation, monterey:       "5abe96d1f1853395741e91c0965f91ae7afed48949ecc800b6787a232742074e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d233059ee09ddf599409014da86b6f87c6738340de52443fed12f7da76ceda5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18e0299740f616331b63cdbee768bea6b026b6251c2f94072a9d560d0833745e"
  end

  depends_on "go" => :build

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