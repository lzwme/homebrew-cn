class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://ghfast.top/https://github.com/fastly/cli/archive/refs/tags/v14.0.2.tar.gz"
  sha256 "5ddee8ef032d238ad0614a65f64b4af6e0f374cc4f311a4212f25f01288cdf01"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54df79c0ec28e3ae7c5b07e5a7f3e56cee6ff0290fdb616513a6d1267bca1b77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54df79c0ec28e3ae7c5b07e5a7f3e56cee6ff0290fdb616513a6d1267bca1b77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54df79c0ec28e3ae7c5b07e5a7f3e56cee6ff0290fdb616513a6d1267bca1b77"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7fd727e637541de59b7f7383a23935d88adfe9f4bf515dadfab9b08a30dcd22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4f1f434b51949738dc5a9411c7bba8909fda83c6087e0f6c5228adaf03a9fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8155f3bef244c0dd865f5e7b7de23450a013f6cbaf1fd881aa174cf75f3a053"
  end

  depends_on "go" => :build

  def install
    mv ".fastly/config.toml", "pkg/config/config.toml"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
      -s -w
      -X github.com/fastly/cli/pkg/revision.AppVersion=v#{version}
      -X github.com/fastly/cli/pkg/revision.GitCommit=#{tap.user}
      -X github.com/fastly/cli/pkg/revision.GoHostOS=#{os}
      -X github.com/fastly/cli/pkg/revision.GoHostArch=#{arch}
      -X github.com/fastly/cli/pkg/revision.Environment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/fastly"

    generate_completions_from_executable(bin/"fastly", shell_parameter_format: "--completion-script-",
                                                       shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastly version")

    output = shell_output("#{bin}/fastly service list 2>&1", 1)
    assert_match "Fastly API returned 401 Unauthorized", output
  end
end