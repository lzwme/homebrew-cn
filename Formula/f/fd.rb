class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://ghproxy.com/https://github.com/sharkdp/fd/archive/refs/tags/v8.7.1.tar.gz"
  sha256 "2292cf6e4ba9262c592075b19ef9c241db32742b61ce613a3f42c474c01a3e28"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52d6ff0f147babfa22162f493c0cc7a97dc57b1461f57eb485c3f9dfcecd3be8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8cae0dad642e8e9675133ffa28b71d0ac8e44d7539cd3d7b2c50de31a9537fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e089fd913851353ebf64ce69b19fbb5b6985c04710c3783c84778359d58d94a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c13159ca10073bc82ce3c955aa0aaa04eee6d98f0693c3eba3e4dd394acd12cc"
    sha256 cellar: :any_skip_relocation, ventura:        "8ea4261b080f82ea6e286bddcf328e75ddff7e2cfc39c3d54329ccfb50716f75"
    sha256 cellar: :any_skip_relocation, monterey:       "98802160ee5705eb5cf8aa5eb1478ee3bc5148073aab33eed23773cfc737b005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "934ac23a2432d4055a59e30d88eb80af723076aad313e55625107a1e4080c931"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish])
    zsh_completion.install "contrib/completion/_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end