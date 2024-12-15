class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https:github.comttscoffmdless"
  url "https:github.comttscoffmdlessarchiverefstags2.1.51.tar.gz"
  sha256 "fedd185416a7c4c88c824f48f13da843d0535f0dded13ead0b6cae7bf174da5d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0dc52539af0c30d353cde6eb4966a2a3cd78888136d449cf727c8224150e5490"
    sha256 cellar: :any,                 arm64_sonoma:  "494ba6d56e4b5f6322e3b221ee0b7324f097354ff6825bae614862a3747c8ab5"
    sha256 cellar: :any,                 arm64_ventura: "00c4f86d2efa11b59ea2b406a1868cae4c717bf45f9fba3df90db3438e42192e"
    sha256 cellar: :any,                 sonoma:        "e45b5ed6f214617c19f6cd4e16cfbc73ada99c841251d5193b05b6beac1f3036"
    sha256 cellar: :any,                 ventura:       "8ffaf68d1afbabf8688fa92e1dc2f461a468a7909e10796b6e2d9b46da7b6a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31ad4305b64dc4aad627f776ca684626b3b4104277270b50ecfe14e6eb02ec47"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  # version patch, upstream pr ref, https:github.comttscoffmdlesspull103
  patch do
    url "https:github.comttscoffmdlesscommit3462d11f8c8dc5936cdae573a6ce9a2837ceaba6.patch?full_index=1"
    sha256 "f8da80dcc221cbf125841aee49da31912b1f3f82208a3fd99c0906e0c930863c"
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec"bin#{name}"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}mdless --version")
    (testpath"test.md").write <<~MARKDOWN
      # title first level
      ## title second level
    MARKDOWN
    out = shell_output("#{bin}mdless --no-color -P test.md")
    assert_match(^title first level =+$, out)
    assert_match(^title second level -+$, out)
  end
end