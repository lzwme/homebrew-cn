class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https:docs.rsminijinjalatestminijinja"
  url "https:github.commitsuhikominijinjaarchiverefstags2.5.0.tar.gz"
  sha256 "63e9f1ece32cc7edea5fc762e3bfe48571f71ec3b112cc8f7b0c1a1619dab81e"
  license "Apache-2.0"
  head "https:github.commitsuhikominijinja.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf6694c32c747e26783b584ec6158cb4e0a8e3e2678662259d792b7f89b994f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "918b300ea03e7997089ed5646925d72d382285db8714d1a9362b061dbaaa9c7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49ef06405b4b488838b9a6d0c862ce61b80eef6370de961f031d9087f32bb2a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b086ab3351008beb5a9f46a644b6da6ebdd4fafac95e3c2186a0431fa3ec606"
    sha256 cellar: :any_skip_relocation, ventura:       "0821ac7038f72ac946b52a5fa5bbce30a0d6bea6bc6d1e791b99f3d87fa3b4a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9d6e5ed489bedb9b0202bd4ce9f3db7c31ee2d7bc6116b61436b84e42d2cd09"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")
  end

  test do
    (testpath"test.jinja").write <<~EOS
      Hello {{ name }}
    EOS

    assert_equal "Hello Homebrew\n", shell_output("#{bin}minijinja-cli test.jinja --define name=Homebrew")
  end
end