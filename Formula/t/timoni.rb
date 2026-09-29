class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://ghfast.top/https://github.com/stefanprodan/timoni/releases/download/v0.35.0/timoni_0.35.0_source_code.tar.gz"
  sha256 "6e246c716da983505b577976fabaf310aa1f864c8b233e16ae418a898d88cab0"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8ed922642fd1e88d679502982f6215dca5d8cc98cea5c270e678b6948eb4d97"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0671a8038a2411d708c73a07def0ce9eaa79a1391c4fcf044407db986b80a5bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0caab4443d26896d8427602112ecbd79b6c11332b4bc5dad028c61cbc76ab32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eecf0267aaae646e2c745d055034f0276ca18ecb3824f58832e602494d522aea"
    sha256 cellar: :any,                 x86_64_linux:      "675c2d44c1ea5ebc0064ed22a2a5793128aeae079e87f5ce5e09ae65f1cbaae3"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=#{version}"), "./cmd/timoni"

    generate_completions_from_executable(bin/"timoni", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timoni version")

    system bin/"timoni", "mod", "init", "test-mod", "--namespace", "test"
    assert_path_exists testpath/"test-mod/timoni.cue"
    assert_path_exists testpath/"test-mod/values.cue"

    output = shell_output("#{bin}/timoni mod vet test-mod 2>&1")
    assert_match "INF timoni.sh/test-mod valid module", output
  end
end