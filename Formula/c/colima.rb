class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.5.6",
      revision: "ceef812c32ab74a49df9f270e048e5dced85f932"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27e5f5d33b611016192830a350327d0afee5e78ab427f61b5e875ed5190e5892"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc8d4942c720c96f887f5f50fe94d83029bc3f88884a8e89c7a48b4d9a5b380d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3d15b3d5c891366808a15603f2f09609b3f3c0544a50c77ff4c1da81a959625"
    sha256 cellar: :any_skip_relocation, sonoma:         "896a76ef2dac37278bf049e0e9ff4367a6cc8984ffb8d1540b0abdbf3da6c99c"
    sha256 cellar: :any_skip_relocation, ventura:        "11fabd88fc6133462ad4da1edc20d7f74d6a6bf1bfc0200e2eb0717be6740623"
    sha256 cellar: :any_skip_relocation, monterey:       "18d6d77974ced4e6a69f9da156e7adfebaca3ba88a5a61652bde73959a4953fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74e40a893364cf8040f0bed8641ce1ab4db1d1823f46d6afe4ad181637b78b3e"
  end

  depends_on "go" => :build
  depends_on "lima"

  def install
    project = "github.com/abiosoft/colima"
    ldflags = %W[
      -s -w
      -X #{project}/config.appVersion=#{version}
      -X #{project}/config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/colima"

    generate_completions_from_executable(bin/"colima", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end