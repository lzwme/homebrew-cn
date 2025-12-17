class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://ghfast.top/https://github.com/carvel-dev/ytt/archive/refs/tags/v0.52.2.tar.gz"
  sha256 "ce442e6dfd26cc0fe2504b16f7aa93d33bd6f8279a757b86b37cfc37dc228d2d"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0254a6414921c1e6956ac61d1e7b1ee1ecca67a5722b19fef729c660a634a231"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0254a6414921c1e6956ac61d1e7b1ee1ecca67a5722b19fef729c660a634a231"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0254a6414921c1e6956ac61d1e7b1ee1ecca67a5722b19fef729c660a634a231"
    sha256 cellar: :any_skip_relocation, sonoma:        "517e1206cebfa6e41940fa956fc41c4011580e23f9a6cd950cc9f219a6f3630e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "919b44fefc8523d1e62afddfb2645a9ac0757b35f27ee2b2eac109d0f240786f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29447001500600bbda41ab028ce8ea03b7e17b3cb178100609f913ea15e80ead"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/ytt/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ytt"

    generate_completions_from_executable(bin/"ytt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ytt version")

    (testpath/"values.lib.yml").write <<~YAML
      #@ def func1():
      name: max
      cities:
      - SF
      - LA
      #@ end

      #@ def func2():
      name: joanna
      cities:
      - SF
      #@ end
    YAML

    (testpath/"template.yml").write <<~YAML
      #! YAML library files must be named *.lib.yml
      #@ load("values.lib.yml", "func1", "func2")

      func1_key: #@ func1()
      func2_key: #@ func2()
    YAML

    assert_match <<~YAML, shell_output("#{bin}/ytt -f values.lib.yml -f template.yml")
      func1_key:
        name: max
        cities:
        - SF
        - LA
    YAML
  end
end