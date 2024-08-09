class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https:github.comkubernetes-sigscri-tools"
  url "https:github.comkubernetes-sigscri-toolsarchiverefstagsv1.31.0.tar.gz"
  sha256 "2cc766986662ed1b9585693a4f24f7f109fa5fa7d62ae62aaafea093d3a119c9"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigscri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80e1d1f06e256f31b17cdf9ccd1b32427fa4343695a8decab66416c7132a2267"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80e1d1f06e256f31b17cdf9ccd1b32427fa4343695a8decab66416c7132a2267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80e1d1f06e256f31b17cdf9ccd1b32427fa4343695a8decab66416c7132a2267"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6d2a96141cdafbf4ecb41e455f8c5c03aed5318c073d2818a898f41a6ba9582"
    sha256 cellar: :any_skip_relocation, ventura:        "e6d2a96141cdafbf4ecb41e455f8c5c03aed5318c073d2818a898f41a6ba9582"
    sha256 cellar: :any_skip_relocation, monterey:       "e6d2a96141cdafbf4ecb41e455f8c5c03aed5318c073d2818a898f41a6ba9582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc81b9152658fba4318250851c9c7a19aa928eda945a16d57e56cf717f6af811"
  end

  depends_on "go" => :build

  def install
    ENV["BINDIR"] = bin

    if build.head?
      system "make", "install"
    else
      system "make", "install", "VERSION=#{version}"
    end

    generate_completions_from_executable(bin"crictl", "completion", base_name: "crictl")
  end

  test do
    crictl_output = shell_output(
      "#{bin}crictl --runtime-endpoint unix:varrunnonexistent.sock --timeout 10ms info 2>&1", 1
    )
    error = "transport: Error while dialing: dial unix varrunnonexistent.sock: connect: no such file or directory"
    assert_match error, crictl_output

    critest_output = shell_output("#{bin}critest --ginkgo.dryRun 2>&1")
    assert_match "PASS", critest_output
  end
end