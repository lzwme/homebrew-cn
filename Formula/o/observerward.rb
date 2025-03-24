class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2025.3.23.tar.gz"
  sha256 "569a7a7c7d1adce237bf151981dcb5dd98009bb4dd4fc7a3e96d7b58fade56d6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1b860d72b57de88d74d10b06db1ccfcbbe2b4f9ddc4938e5265b13bcc4c7934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fcef1fcd4fe8037d843f9f4d9e86b8a7c10de8d8b8b09143df3c1ddba2e8d0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "314ce22acb8e7294a13b79a3e27d367f8ffd641f3b62e82d600ffac1ebd98aa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f37df0d086d902784f76fb54b261419e30c873f2cb65e3afa2780a540509c749"
    sha256 cellar: :any_skip_relocation, ventura:       "b36705e37778f49ad1a378e9c3181a786d302a031373f36fc82452845718160b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "537cb4353e9d0636c7a68313c4cc0eefa6d56815729425aa5f8c7ee15f7f6f41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utilslinkage"

    system bin"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}observer_ward -t https:www.example.com")
  end
end