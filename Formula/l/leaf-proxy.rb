class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https:github.comeycorsicanleaf"
  url "https:github.comeycorsicanleafarchiverefstagsv0.10.8.tar.gz"
  sha256 "be62ca2c6c3e0c387fceea5da31c901d8b6da40b80298d2d0e7e77ff688f0c09"
  license "Apache-2.0"
  head "https:github.comeycorsicanleaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecbfc40acb1ccae5b5610a3ffbbdd15e323582b78603845ed9701ef6aee78b0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e0c744e6c816882012efc4ce3255d7feed06db6eb45fe853535db026e6084dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d77991c0755c8f8069493b35b9aec1567ca79e89b81147e3dc672850b78ce97"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee6394210259b026df440a070b91f604768c3eface86e5ae3783b76b6d3caf5d"
    sha256 cellar: :any_skip_relocation, ventura:        "cd9baf7b1c9dffe71da54a6bfcbb81c1947bc29126734b5f59e3a929c54cb375"
    sha256 cellar: :any_skip_relocation, monterey:       "8b027f54796783f2bf650136e44cff37810d46a149eb97fd59fc8f42fec729ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2299be4349559439f9bbee0c7c91c52093622215fa98faa19cca0b85ddb76bc"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "leaf-bin")
  end

  test do
    (testpath"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}leaf -c #{testpath}config.conf -t SS"

    assert_match "TCP failed: all attempts failed", output
  end
end