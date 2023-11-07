class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://ghproxy.com/https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "37dd7373b952f35b7b56f891fe7ab374fb32a3f3f4add1807b95f5ae402d00f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3d625b90b8ba5fe1e6b96fffb2cb9d6ed08cbe6563a5bca488706d948f7abcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c14d764e48c60278d92b430c650843dc12e478f3755154744b72db3527412d4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8d61fa2b9dc999426600c82869c6153ae552baa2c7eb3de4cf43d287832c227"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e91b661a744ab6c8ce9b52d4f8663b57bcdb494d129d39d30e19a895c1e4c14"
    sha256 cellar: :any_skip_relocation, ventura:        "50a40ac940817b8c5a74e24fc82675320578d368296c9df52041c1bb4a9f3f7a"
    sha256 cellar: :any_skip_relocation, monterey:       "50df0b44c93c994e12956d4c14715b98e88281d2ee014884be504427effe98b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f6c346e00d050fa9298c8f0aa5177ac19214958d498d1e0f16f74942cb24f40"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      line.include?("Initialized status surfacer")
    end
  end
end