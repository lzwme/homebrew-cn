class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https:www.fastly.comdocumentationreferencecli"
  url "https:github.comfastlycliarchiverefstagsv11.0.0.tar.gz"
  sha256 "4a0b6543cbe5c2a25faf7fd4ad4e1bb8a960cbcc3340d55220ad627f87522f20"
  license "Apache-2.0"
  head "https:github.comfastlycli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2db6cc3b60566b43710dc7212121d044e243dffe8d4215f13f175e57e04223f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2db6cc3b60566b43710dc7212121d044e243dffe8d4215f13f175e57e04223f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2db6cc3b60566b43710dc7212121d044e243dffe8d4215f13f175e57e04223f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4179f43556e6d4a94503204a5d990812683fc516e9124eb26e2917934dabafcb"
    sha256 cellar: :any_skip_relocation, ventura:       "4179f43556e6d4a94503204a5d990812683fc516e9124eb26e2917934dabafcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94d92997a57b102af919ec34ee82c0ce5946da7c406ad89b5cc016f52a27553"
  end

  depends_on "go" => :build

  def install
    mv ".fastlyconfig.toml", "pkgconfigconfig.toml"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
      -s -w
      -X github.comfastlyclipkgrevision.AppVersion=v#{version}
      -X github.comfastlyclipkgrevision.GitCommit=#{tap.user}
      -X github.comfastlyclipkgrevision.GoHostOS=#{os}
      -X github.comfastlyclipkgrevision.GoHostArch=#{arch}
      -X github.comfastlyclipkgrevision.Environment=release
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdfastly"

    generate_completions_from_executable(bin"fastly", shell_parameter_format: "--completion-script-",
                                                       shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fastly version")

    output = shell_output("#{bin}fastly service list 2>&1", 1)
    assert_match "Fastly API returned 401 Unauthorized", output
  end
end