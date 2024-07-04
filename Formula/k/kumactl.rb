class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.8.1.tar.gz"
  sha256 "9e9abe30208067f49b6e6f29c77dfe1aec10cf9fb52d1adccac233b0e1c7aeb2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34337162f2365e9db4b22d2fb434c3d7afe3ec66be5813852b2ab07dd7f060f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "775a6d0f6616577e483381bb832c1c3fa1119bd4f5da32c0f7d15fa46ccd2ed5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f0f7a05e133fb8a426b14df3fe9d222de9466760e6124e144a1d288b6738986"
    sha256 cellar: :any_skip_relocation, sonoma:         "486cb21d21832b7b9077a3876b733cf52e77c89ea23098f2bea94bf82835f029"
    sha256 cellar: :any_skip_relocation, ventura:        "cb76348da7a2ae02174cbc73dfd14faeefff1532f54f0c5d62fc563da3b1d079"
    sha256 cellar: :any_skip_relocation, monterey:       "ed7b3230c22fd09f2b8caa322f91ea57ef12007f4e0a599a1bdc8e545b334ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b225b43d570f5743a95c83959dd9242208ae62eed7d6341c0fb8dd209cf9ecf"
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
    assert_match "Management tool for Kuma.", shell_output("#{bin}kumactl")
    assert_match version.to_s, shell_output("#{bin}kumactl version 2>&1")

    touch testpath"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}kumactl apply -f config.yml 2>&1", 1)
  end
end