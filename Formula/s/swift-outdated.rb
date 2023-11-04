class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://ghproxy.com/https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.8.1.tar.gz"
  sha256 "e0092acf642b9689a89223385d4a2886751516e8c4dc0240277244cdc6f22449"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac6839c9a3b7a883000a432a7ea36cf5a0b5422827afd40b243b971c24b99ff3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07d9b16c637234ba1b34ec116fa416f2d47f13b262244e1cf88706dad8b919fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ff20e44402a59e4afae74c44ea3bc39f07613b0c409b7bdc470758acc5ba3ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "28c7b8e6bb6687625310336f43123e797500c08764c48d32711607de2095c94e"
    sha256 cellar: :any_skip_relocation, ventura:        "1497ed9d0629176469e1a5e34836aeb36ec9f1336b8e34d8135e67bb5c494900"
    sha256 cellar: :any_skip_relocation, monterey:       "fff809c2f6db2b76d19f6b33fa3439e760bda8feba8529c5b8ded9ac6595d9e9"
    sha256                               x86_64_linux:   "5a6dee0598bced60150f06adb1b9ca0705fae1ae85eb55da665dcd55b4acb5b5"
  end

  depends_on xcode: ["13", :build]
  depends_on macos: :monterey

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swift-outdated"
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end