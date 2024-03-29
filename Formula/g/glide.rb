class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https:github.comMastermindsglide"
  url "https:github.comMastermindsglidearchiverefstagsv0.13.3.tar.gz"
  sha256 "817dad2f25303d835789c889bf2fac5e141ad2442b9f75da7b164650f0de3fee"
  license "MIT"
  head "https:github.comMastermindsglide.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a42135733f71a56ad1f1e3e02590197f33be87977db5ccb7c6dbda7c7f66aa21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b144dd317465f533ba1f1da934648a7a450024d11b7f3c8156e561536b06b0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80dcd1ffaf3206bd1cc26700523f6016c048311d90522c8b0d12fa94a5ee4d03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77ff52f69bde39ac4ba11eec08cc4c7ef5fab166ab801f513486d0a62e448ead"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbe5a4272532ea3064f476247809757db790d9e408931b44a557a3c8def3cddf"
    sha256 cellar: :any_skip_relocation, ventura:        "0343e52ebaf1bdf6460f4b77420d47c91692c577e2727efb933fa085f4021820"
    sha256 cellar: :any_skip_relocation, monterey:       "a8db9273c71c29a5636492db3e9c5ceb64dcafce21ac56ee201fd71b7055b8ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "33a39604d9007bf46e92a0a9131a59c15162dce6ace8b498a91110bc7d316f43"
    sha256 cellar: :any_skip_relocation, catalina:       "014fc42198c07253f844ea7b20b1a9378b08cfb445e548b307c6fb131bd44565"
    sha256 cellar: :any_skip_relocation, mojave:         "7f4be1018eba40d85aca555364a09f97a18d8e09c71e6bb42e6ca1a2c0866865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c979cb9d502737595846ea776057be21e197ede804b10431b4cf5dcc0fee802d"
  end

  # See: https:github.comMastermindsglidecommitc64b14592409a83052f7735a01d203ff1bab0983
  disable! date: "2024-01-21", because: :deprecated_upstream

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    glidepath = buildpath"srcgithub.comMastermindsglide"
    glidepath.install buildpath.children

    cd glidepath do
      system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}glide --version")
    system bin"glide", "create", "--non-interactive", "--skip-import"
    assert_predicate testpath"glide.yaml", :exist?
  end
end