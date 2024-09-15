class KertishDfs < Formula
  desc "Kertish FileSystem and Cluster Administration CLI"
  homepage "https:github.comfreakmaxikertish-dfs"
  url "https:github.comfreakmaxikertish-dfsarchiverefstagsv22.2.0147.tar.gz"
  version "22.2.0147-532592"
  sha256 "a13d55b3f48ed0e16b1add3a44587072b22d21a9f95c444893dbf92e19ee5cee"
  license "GPL-3.0-only"
  head "https:github.comfreakmaxikertish-dfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f43561e5caee7feb03b4acf86b568ede2d584dae9298c6dce30ea2aae0716c55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d055665f0250d3853209ad1be451fed582c6c483fbbf4ad67feb56edbc2c3004"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dddc21a1847c5a75729b2eeafe55ae1916a12457cf727fb8b65c72ffc2c5f2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3f56111dd712f97ff71450eb7f09577e5dc0108482de91064c57fc312609b4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e13c905be95c3f1d28bda7568811d2824e1125126f7a6f99a40aa937994a4fc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "4485a5dd73db9f1f873808e0522299f2f2d7e0d70b283df7764b9dc6f6899f87"
    sha256 cellar: :any_skip_relocation, ventura:        "28dc3892e2e452effd229c826451d2231862bf235c2fb4e32a12d5cebbf3626f"
    sha256 cellar: :any_skip_relocation, monterey:       "08510e2f6ab40696f456d604a7d79372dfd585cc41c0b3703f2c09c7432a1483"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9abefe4002333c21d00fe422d4d22b79fb665f923539e92e9da243eecaa0236"
    sha256 cellar: :any_skip_relocation, catalina:       "9faebdf52cff91734a78c929bb51cd460fffd6f8334c5e42c6db8ed8b337b023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa06124d7915154e90dcd81cd7a25888fa2baaecae519cc7cd8fed706f7b4fca"
  end

  depends_on "go" => :build

  def install
    cd "fs-tool" do
      system "go", "build", *std_go_args(output: bin"krtfs", ldflags: "-X main.version=#{version}")
    end
    cd "admin-tool" do
      system "go", "build", *std_go_args(output: bin"krtadm", ldflags: "-X main.version=#{version}")
    end
  end

  test do
    port = free_port
    assert_match("failed.\nlocalhost:#{port}: head node is not reachable",
      shell_output("#{bin}krtfs -t localhost:#{port} ls"))
    assert_match("localhost:#{port}: manager node is not reachable",
      shell_output("#{bin}krtadm -t localhost:#{port} -get-clusters", 70))
  end
end