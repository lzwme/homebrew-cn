class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "0dc7fdfb691a65c099231a40bb396f87a68914f5c352e1f2fb8ebd765495f2f1"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4af77662394a63d957bb710f7d873ddc5233257fa33a75f7d35f26064355cd09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4af77662394a63d957bb710f7d873ddc5233257fa33a75f7d35f26064355cd09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4af77662394a63d957bb710f7d873ddc5233257fa33a75f7d35f26064355cd09"
    sha256 cellar: :any_skip_relocation, sonoma:        "b23b24c6aab508005e09df9e1be6ff4df73d1633ed4fcbb3fe2e3bd1dc08e916"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80b17c5fd3ee3adb7d04f9e32d5d6b8e206527ec44c73c5b8013f87ba0df40d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "167d050eca75f5fa86d10cd6b43f3b77a81dea421062c0d5fa91e8a41296a841"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end