class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.23.tar.gz"
  sha256 "754d0e40f488a674437e835059fa38c1ea98e9d16e79a8a56b883ead97e8127e"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9faef18c15b48d8ebd4511d97dfde9b65d10a9d76e234139e8c5704f8229d0e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9faef18c15b48d8ebd4511d97dfde9b65d10a9d76e234139e8c5704f8229d0e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9faef18c15b48d8ebd4511d97dfde9b65d10a9d76e234139e8c5704f8229d0e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a92fac95e39e3805792e8b376caa855062e19e53cc6806527cf801e6b729b4a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b26390f176f94f3a6c754378a4ab77f0e83ae849f4856cb0330d92fc9ca7f4d"
    sha256 cellar: :any,                 x86_64_linux:  "85bd58952c9d450e57a1ac46e3113e44d0166a6a2e3ad3992681546e4780bf9c"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end