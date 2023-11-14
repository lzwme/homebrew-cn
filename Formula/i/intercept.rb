class Intercept < Formula
  desc "Static Application Security Testing (SAST) tool"
  homepage "https://intercept.cc"
  url "https://ghproxy.com/https://github.com/xfhg/intercept/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "9670a5cd43407cf26cc19fd0d0c9fef6f2ac2b46b4bd69b999b3932259e86020"
  license "AGPL-3.0-only"
  head "https://github.com/xfhg/intercept.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00b60f3cb72b046e0ec2ab4de14621671ae9b047e33f46e064ed07c0cefd95c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "061be5b71333292fa7e261ef6d61241ad34b766f0c6a3575b80e11a62eb5285c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c16f931334c50458d2e9412ace7a7bde8979414a01f3c03074f97a8d7980a2b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ced7ddba62f63c4960c5be00bbb7fa06558d2a359fa806adc57a5c71e220421"
    sha256 cellar: :any_skip_relocation, ventura:        "4bbac1b25675a94edb1386b3b9fa600d0ee9436aeb9a9a4cc53c19dd6d39620a"
    sha256 cellar: :any_skip_relocation, monterey:       "d04dec14b2a7d162b619d9a01ee3d374e8c3cda881bb96c4eb1fe8cf3c8ea2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a42873e58969e38c58ba4b030c23f09beb7a2aa2b1e2d39a39e2f940168d5a91"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"intercept", "completion")

    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples", testpath

    output = shell_output("#{bin}/intercept config -r")
    assert_match "Config clear", output

    output = shell_output("#{bin}/intercept config -a examples/policy/minimal.yaml")
    assert_match "New Config created", output
  end
end