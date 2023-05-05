class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://ghproxy.com/https://github.com/replicate/cog/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e62d6bcf7c96b3e80c8705322434b1e47ef436b58a4527ebbc6502a4d4187677"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bdac40bcb52d107ef8be0888ec318aec361182e7ccd3fd25eca4316a3f79e21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "522cc5abb4a9763980318d2103d56959feb98969e75fc9f1afc03f45bd584dfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "793290a66eb05219a4eb6c7f5921db61bde96746917dd12081e9e92a1c1204c0"
    sha256 cellar: :any_skip_relocation, ventura:        "675d45c0e7423a07234786c8b2d6a32dc63910b9ce6dbac2b7883e41d1f3799f"
    sha256 cellar: :any_skip_relocation, monterey:       "20c51aa0272db986acfcefc12c03aec5154366c48506a44601e8de0a513efa67"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e369dd715b530844a6d733b3fda6367ed85df28a7dcd34e1959018943172308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe7b6e5917238c89dda00d95125e2227939c3e015959bebe5ddca0e1f4d3de47"
  end

  depends_on "go" => :build
  depends_on "python@3.11" => :build
  depends_on "redis"

  def install
    args = %W[
      COG_VERSION=#{version}
      PYTHON=python3
    ]

    system "make", *args
    bin.install "cog"

    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end