class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://ghproxy.com/https://github.com/replicate/cog/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "95a9fca755c4cbf2fa6955bf2bbb2cc083e0b2f4066c2def0a5290424c9cb3b9"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43c1aeeba75d7508f8b1f31da02df8f2282b203335b4a1d40c1fc0c37cc1800f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "583b5c9ac18ae91dd509ede943c19bb1e024d0a58b63e7c05242cab4da2fd2ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22a6462c73a2017f1fe790efd27559293256bfecb66fae1eee8efa2159bdb38e"
    sha256 cellar: :any_skip_relocation, ventura:        "55bada9614fd53d091ab405455b7c509fd88fcbc89c9de45c3b832b5fa18b99c"
    sha256 cellar: :any_skip_relocation, monterey:       "3483e3270fa57e7bf12edb09bfe7ff4ae3ecc77f0e6156aab457572ce99386d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0ec86e2daead7f4904abf7f587574f1567c363f81f4b44b603e04732e4555e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b98f057089e002f63bf94f94ab28574616f4491f48d18e1c159b261261786530"
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