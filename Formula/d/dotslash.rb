class Dotslash < Formula
  desc "Simplified executable deployment"
  homepage "https:dotslash-cli.com"
  url "https:github.comfacebookdotslasharchiverefstagsv0.5.5.tar.gz"
  sha256 "15d5c66afe187f220d86ec99cd34f54ac75b651477299e7d5fc12332207c49a6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30240fc41285c820e87a3daf43552fe3a73e3f9344716ab92fb2d8dccea67726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d90b2879d2504d8f31e7dd12e1679157c16323b7a4c452cfba130ce660e3a9b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70af2562f4c1133ea468fd052994dd7ee3b2d2d258b664c09f89251c73e3085b"
    sha256 cellar: :any_skip_relocation, sonoma:        "733dfe7e2e052ae09a43487ea480d29b4ec7bff27963f4626db6691e1deb1ce9"
    sha256 cellar: :any_skip_relocation, ventura:       "1b05c51e7eee30dd4d627112ef070deaca13ab2fdfc7291670647f6ed17a4e5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c373a68e0e7df3ca25ad4895c7c4ef2098ff22eecc0fc9c334885035833a483d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3764d7bf7fbc0f9b0c205d4b5dfec07b8193a7a20f43dcc92d8184a4d7255a3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"node").write <<~EOS
      #!usrbinenv dotslash

       Example file from https:dotslash-cli.comdocs.
       The URLs in this file were taken from https:nodejs.orgdistv18.19.0

      {
        "name": "node-v18.19.0",
        "platforms": {
          "macos-aarch64": {
            "size": 40660307,
            "hash": "blake3",
            "digest": "6e2ca33951e586e7670016dd9e503d028454bf9249d5ff556347c3d98c347c34",
            "format": "tar.gz",
            "path": "node-v18.19.0-darwin-arm64binnode",
            "providers": [
              {
                "url": "https:nodejs.orgdistv18.19.0node-v18.19.0-darwin-arm64.tar.gz"
              }
            ]
          },
          "macos-x86_64": {
            "size": 42202872,
            "hash": "blake3",
            "digest": "37521058114e7f71e0de3fe8042c8fa7908305e9115488c6c29b514f9cd2a24c",
            "format": "tar.gz",
            "path": "node-v18.19.0-darwin-x64binnode",
            "providers": [
              {
                "url": "https:nodejs.orgdistv18.19.0node-v18.19.0-darwin-x64.tar.gz"
              }
            ]
          },
          "linux-aarch64": {
            "size": 44559104,
            "hash": "blake3",
            "digest": "bd605f5957f792def0885db18a9595202ba13f64d2e8d92514f95fb8c8ee5de5",
            "format": "tar.gz",
            "path": "node-v18.19.0-linux-arm64binnode",
            "providers": [
              {
                "url": "https:nodejs.orgdistv18.19.0node-v18.19.0-linux-arm64.tar.gz"
              }
            ]
          },
          "linux-x86_64": {
            "size": 44694523,
            "hash": "blake3",
            "digest": "72b81fc3a30b7bedc1a09a3fafc4478a1b02e5ebf0ad04ea15d23b3e9dc89212",
            "format": "tar.gz",
            "path": "node-v18.19.0-linux-x64binnode",
            "providers": [
              {
                "url": "https:nodejs.orgdistv18.19.0node-v18.19.0-linux-x64.tar.gz"
              }
            ]
          }
        }
      }
    EOS
    chmod 0755, testpath"node"
    assert_match "v18.19.0", shell_output("#{testpath}node -v")
  end
end