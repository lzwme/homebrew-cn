class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://ghfast.top/https://github.com/0xerr0r/blocky/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "bcb8671d54581374ce1683492fd5722e0f0c3361d10c9d32ded10ea5e40f6443"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c50363b2b5c8c2c3b5214e54c66bfbdadc903bcb13946f47f80d3d1e4db040f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca49797ef2cb1ef5b1e661bdd21ba81d76c7cee9d7a2d864271c0c2204f32908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "133d8bebbd2a4d8abd23c385fc35715807af1037e58c54ac09ddb1a245f6f24d"
    sha256 cellar: :any_skip_relocation, sonoma:        "73083edd9562fa818e56c35db72b15b18f87ed8bb7c5a79ff420c87647c2e25a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "580026759e7facba2d8cf473687b38c88803f97875f1071b0ed7bf0d67b9aaea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a08a1ba59a6a38fb5f7c538252f3718306f3141165d1ef5116ff500afb52ea0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: sbin/"blocky")

    pkgetc.install "docs/config.yml"

    generate_completions_from_executable(sbin/"blocky", shell_parameter_format: :cobra)
  end

  service do
    run [opt_sbin/"blocky", "--config", etc/"blocky/config.yml"]
    keep_alive true
    require_root true
  end

  test do
    # client
    assert_match "Version: #{version}", shell_output("#{sbin}/blocky version")

    # server
    assert_match "NOT OK", shell_output("#{sbin}/blocky healthcheck", 1)
  end
end