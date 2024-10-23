class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.9.0.tar.gz"
  sha256 "21f2353ad23e688d6c87be012b53e8cac9d6e2269a2acf486b6622855b3abe64"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "726483ebec55231cb0366621452d90ee668c9861f50a0139320698a9d9616b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "726483ebec55231cb0366621452d90ee668c9861f50a0139320698a9d9616b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "726483ebec55231cb0366621452d90ee668c9861f50a0139320698a9d9616b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7c1c6bc51c4133e3c6af9c97facba3c4d393d557061a3888387c5c405afcd28"
    sha256 cellar: :any_skip_relocation, ventura:       "a7c1c6bc51c4133e3c6af9c97facba3c4d393d557061a3888387c5c405afcd28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73aa97bcbe455e1a84a1f3c3e0f5a5039b402b95567e6e403aa30843f1d024e"
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