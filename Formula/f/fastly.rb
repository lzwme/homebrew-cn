class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https:www.fastly.comdocumentationreferencecli"
  url "https:github.comfastlycliarchiverefstagsv10.19.0.tar.gz"
  sha256 "0f9f256c3c3636cd5f19ac79c6b140f4bdc26cf6320ba919479c4fa55335e8d6"
  license "Apache-2.0"
  head "https:github.comfastlycli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "938771676a0ef36958ecbe40229d692c62c557eea1b700c3e0e0fa76b23a2b69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "938771676a0ef36958ecbe40229d692c62c557eea1b700c3e0e0fa76b23a2b69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "938771676a0ef36958ecbe40229d692c62c557eea1b700c3e0e0fa76b23a2b69"
    sha256 cellar: :any_skip_relocation, sonoma:        "8953388559ef3660d4bb04a1c13206958afc0f52dfbbebd3f0a4d5331f372960"
    sha256 cellar: :any_skip_relocation, ventura:       "8953388559ef3660d4bb04a1c13206958afc0f52dfbbebd3f0a4d5331f372960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34267c566806213e3ec9927d8a973ad99b71b5732b46f4e910af933d7364afe0"
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