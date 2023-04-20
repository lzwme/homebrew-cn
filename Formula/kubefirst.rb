class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "442449642f2405b31cb00e4f38aed2898d326f91108296424122f44078f610a3"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d0ce3de9dd43a2e806b8622dd351767212b1525d923023f10bded3dd2405c53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06678c9485c81b422c5cfb04d66f1652a51198888ec546bc4a868080b494dbfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "256f28e9c8d16b80a19e3546d4ae2fd731cc10ad5525aa1ff9860eda41e85a21"
    sha256 cellar: :any_skip_relocation, ventura:        "f91eec8577c0f1d5304022b5de63ec822e9bd5c0b1a4edbfd54431a81d5aa2f8"
    sha256 cellar: :any_skip_relocation, monterey:       "531d9e6042dae6b92f626268b9594033bfe0f0f47bbed835795b702d98419e19"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cf6e3771d9602a1da2ab481e941d81edb413a762eaadc5748faf37967fef06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "380fdc57d7fa7c7f89e993fbca5220a656bbe5ebf5e066bab7c206ad24502da0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match version.to_s, shell_output("#{bin}/kubefirst version")
  end
end