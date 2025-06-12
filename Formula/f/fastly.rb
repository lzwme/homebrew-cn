class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https:www.fastly.comdocumentationreferencecli"
  url "https:github.comfastlycliarchiverefstagsv11.3.0.tar.gz"
  sha256 "e2684f5c727e1e1d1fdc797c5bafee9fe0936f6a69198244e12a5db283c7bc96"
  license "Apache-2.0"
  head "https:github.comfastlycli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f037b9b981364cb6d7178353c71c38c653b1f47e0c2bb860c09113e5a26cb2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f037b9b981364cb6d7178353c71c38c653b1f47e0c2bb860c09113e5a26cb2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f037b9b981364cb6d7178353c71c38c653b1f47e0c2bb860c09113e5a26cb2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1bac4fa478adbd0885f423194edc18dd99a9fd38baee43cfb7ed34227cfddfe"
    sha256 cellar: :any_skip_relocation, ventura:       "c1bac4fa478adbd0885f423194edc18dd99a9fd38baee43cfb7ed34227cfddfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de2ae9ca493cff10e9d79c73c4f5107e6179e491c10481b2ca4b54f86437b6c8"
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