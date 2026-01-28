class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://ghfast.top/https://github.com/carvel-dev/ytt/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "a2bbfa57d42ce0f6e902759fafa6ee0a8451287a1f13896ce245cdccd323453e"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3671dcc301fa479467bee7da5991d1d168ff7aab4bc70e3ce34e287bc7224925"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3671dcc301fa479467bee7da5991d1d168ff7aab4bc70e3ce34e287bc7224925"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3671dcc301fa479467bee7da5991d1d168ff7aab4bc70e3ce34e287bc7224925"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2fd2576b239a134a0f28ba33103429319c061eabb60d06b0b8dc512200f8155"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "037ad1a610273ab72834dd9bcdc9cb868308d45ee2c5a30556183408da7038a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3976a0d0c388ddf9e1f7755c73959df6015a31567964edd50aa16b2dec7f4574"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/ytt/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ytt"

    generate_completions_from_executable(bin/"ytt", shell_parameter_format: :cobra)
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