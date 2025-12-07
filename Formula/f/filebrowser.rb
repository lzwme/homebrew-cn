class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.51.0.tar.gz"
  sha256 "83807c5330343a4f1201e0e061725769628d87b9a5bdd9486967a8f880ce6571"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6741495db633e39b5ce9f04b776f4941785f72edddfa1374c5f1157a915cf238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c79c218ac728966e0a435879fa09c2de236a68065a61100e785fb72a2e874fc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da50b99031cef6ec9c0c5a73038d4e99901e258e5d861be00252ee78dbbf8619"
    sha256 cellar: :any_skip_relocation, sonoma:        "b49765f45fdbdd28f8bde5018f7a721ab0aa9201f16233d3bc8752ca5906e9e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8644bc640ed854a894ff72e02f08676fd3fb924a956e7e14afdddffcfb5cff0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ff1a78ec4f38bf13ea1052ea74d1066fe16a5d91e2122af49f3f250f8a05c0f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end