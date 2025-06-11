class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.11.0.tar.gz"
  sha256 "1887e12a27b779d41111347bc5181573165cf6063bbcd622b50977d26c4e2a59"
  license "Apache-2.0"
  head "https:github.comkumahqkuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a14f8ecde3f956668c5a413efefaf62901e1af6bae83675be8192036ad93acb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aec60ed322e4f7ad6646aefb1ba2393828d4c140a5b59a32d21cab24b3e2d100"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92444fb885e08878477ef32998a416570f72af94b8ae29286315d447a02be728"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9f9e0982545ca3da856771202859e5e6ddc6d90ec5e0a31d4dd4638bfb72ff2"
    sha256 cellar: :any_skip_relocation, ventura:       "d2f8381c0148b4c8691707a4c488ae9f19a0ba1fe69d88355cc892f7fa65da79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75e6fd85da20ffcb92ebdb1e883380826e071ba1f0113a892b6f8d214bf7cff2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkumahqkumapkgversion.version=#{version}
      -X github.comkumahqkumapkgversion.gitTag=#{version}
      -X github.comkumahqkumapkgversion.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), ".appkumactl"

    generate_completions_from_executable(bin"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin"kumactl")
    assert_match version.to_s, shell_output("#{bin}kumactl version 2>&1")

    touch testpath"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}kumactl apply -f config.yml 2>&1", 1)
  end
end