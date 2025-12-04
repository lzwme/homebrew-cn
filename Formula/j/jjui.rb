class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://ghfast.top/https://github.com/idursun/jjui/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "ba400c7c7fa6ea490ba271895cc8aabba409004b690040f8de69fe625e09b546"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78ac8e0e220c7003ab0675e908778b1a5293f8b2c263f402a6c6fbc94b6c37de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78ac8e0e220c7003ab0675e908778b1a5293f8b2c263f402a6c6fbc94b6c37de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78ac8e0e220c7003ab0675e908778b1a5293f8b2c263f402a6c6fbc94b6c37de"
    sha256 cellar: :any_skip_relocation, sonoma:        "2102d9f0433da1ad0ce83c61208c9c5bbdd24e3f8bbf2e5c64bea2b69cce90a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e26a0795cd7a20a0939c4ee984f11b6e7e3f4ef908eb56ea0ead9bb632502113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64018a0a34ba23f4d1220185809f6979e3b546cd81a6cdcabe02424a2380ddf8"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end