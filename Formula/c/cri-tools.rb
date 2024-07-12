class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https:github.comkubernetes-sigscri-tools"
  url "https:github.comkubernetes-sigscri-toolsarchiverefstagsv1.30.1.tar.gz"
  sha256 "f4aac1636c2a6bbf98e4ad314b8965ac1f417b8bb82640f3a297173f7e5551b5"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigscri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e6a15ec7d79fe010ac47e59652e0583b3f53bddaa85b406a46e3187f5ad0cf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e6a15ec7d79fe010ac47e59652e0583b3f53bddaa85b406a46e3187f5ad0cf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e6a15ec7d79fe010ac47e59652e0583b3f53bddaa85b406a46e3187f5ad0cf9"
    sha256 cellar: :any_skip_relocation, sonoma:         "00c4dd913ef6237e138888a319e81f43dc9267aac1304e23f58c1b06ab6e26aa"
    sha256 cellar: :any_skip_relocation, ventura:        "00c4dd913ef6237e138888a319e81f43dc9267aac1304e23f58c1b06ab6e26aa"
    sha256 cellar: :any_skip_relocation, monterey:       "00c4dd913ef6237e138888a319e81f43dc9267aac1304e23f58c1b06ab6e26aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d253e204ae08dc2f61b33d8f2c8dae7532f7e147e5652dc6e1e8f519fcf018"
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