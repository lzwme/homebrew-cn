class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https:github.comviaduct-aikustomize-sops"
  url "https:github.comviaduct-aikustomize-sopsarchiverefstagsv4.3.0.tar.gz"
  sha256 "639575d41f4c3ad152fdb2a0e9533829217f4417bcd13338e2a47f204629e8ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6647c98a5fb6ce1c396d45a72b9d7dec883c466c5b19f664a4e2aa7957f038ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8536d6e41bc409e34278093a073d99edac2b1828f2f2ab747d91e9a9bdc9e03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6841bb31d550b4fd51651d14cd7af1c3cca66a2c9f00428452462b60850f500e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f53e53e5b8f201212f005440761d4cf8ce41286f3fdbe5dcc3d4ace2355d0e0e"
    sha256 cellar: :any_skip_relocation, ventura:        "70a584e33bb8e981d9d7ae781ff5f56c9271f3ef62be271ad7f706fb0378066b"
    sha256 cellar: :any_skip_relocation, monterey:       "787e768a33f117f83218de92396cbb2bc0c8523e96c1e0fd958a95c6481d4129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8f284d93b1b134d9d9a17b22c72823af0aa5d3fe88756d3ac5922d550c20e8c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"secret-generator.yaml").write <<~EOS
      apiVersion: viaduct.aiv1
      kind: ksops
      metadata:
        name: secret-generator
        annotations:
          config.kubernetes.iofunction: |
            exec:
              path: ksops
      files: []
    EOS
    system bin"ksops", testpath"secret-generator.yaml"
  end
end