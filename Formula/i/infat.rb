class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on MacOS"
  homepage "https:github.comphilocalystinfat"
  url "https:github.comphilocalystinfatarchiverefstagsv2.3.4.tar.gz"
  sha256 "5dd263952f49617ce688d3ec6c043e3dce8c5766fab9a4aef31f99c010c1ccd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e263c627344fa10c4373c6f7f76b96bbf090703a2e1761ed247f04f385deaf56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db3419a6e095edcea41b5a029dcbc2aa1a94b70c684e42c67e38019de59dbf69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c57aaf12f258985b59315f828aaee79cb6fda188dca639a29407205cef827ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "76e0af0201e4226d74e7b95c0217b0b3a1bdd21f98de04cf2c7f07a7d4bb6d3a"
    sha256 cellar: :any_skip_relocation, ventura:       "be3d4afc2a8963e9e6bdafdf6b6dd7522b5bb0594fabd7bec6a669eeeaac78e9"
  end

  depends_on :macos
  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".buildreleaseinfat"

    generate_completions_from_executable(bin"infat", "--generate-completion-script")
  end

  test do
    output = shell_output("#{bin}infat set TextEdit --ext txt")
    assert_match "Successfully bound TextEdit to txt", output
  end
end