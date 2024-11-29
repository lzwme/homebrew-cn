class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https:github.comfullstorydevgrpcurl"
  url "https:github.comfullstorydevgrpcurlarchiverefstagsv1.9.2.tar.gz"
  sha256 "9259935b6ef86d701caef60be338600798348368c0f4dca063a45cf88d8186a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0e605c34c85402e9fe66fef34eed0939a0ad43c185bcbd3a9073df5896f5d42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0e605c34c85402e9fe66fef34eed0939a0ad43c185bcbd3a9073df5896f5d42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0e605c34c85402e9fe66fef34eed0939a0ad43c185bcbd3a9073df5896f5d42"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7bf5a847cacaef832a85655c36c22c5d38aaa8919188ce0595de2a3cb45711c"
    sha256 cellar: :any_skip_relocation, ventura:       "e7bf5a847cacaef832a85655c36c22c5d38aaa8919188ce0595de2a3cb45711c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "392591de30468ffd85c19e811d50b6f461f0bfa778cd540e482e08acf5ae9647"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), ".cmdgrpcurl"
  end

  test do
    (testpath"test.proto").write <<~EOS
      syntax = "proto3";
      package test;
      message HelloWorld {
        string hello_world = 1;
      }
    EOS
    system bin"grpcurl", "-msg-template", "-proto", "test.proto", "describe", "test.HelloWorld"
  end
end