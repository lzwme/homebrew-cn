class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.11.5.tar.gz"
  sha256 "3f229831051fb43bb01781d37f160eaac6d1b30a384ca08ef505d0896a0be333"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a27359fc5fcf36cc96a33b747ed448ae6e862ae2e7df46d242f76825db5b0d63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f477a045acfe32d392361f9140f59b22faccda3d27bbf9ae0f649f08d6c0c9eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a84b873bb3517742efe50819a06513c0374fff2fd70e3f639ef7244558728077"
    sha256 cellar: :any_skip_relocation, sonoma:        "f713fc6a7539625e5e5d868ad94c45b7db45e67df64a8dfeb26547bb481ccd9a"
    sha256 cellar: :any_skip_relocation, ventura:       "7987c0dc184893d901c10b35c969376043bb190aa4e62a13d233915d99248c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df43be5db20a2a2e15accc460abaaefcf427fa3e11a84d6710b61e50b9c9a9be"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargoconfig.toml"

    system "cargo", "install", *std_cargo_args(path: "cratesswc_cli_impl")
  end

  test do
    (testpath"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath"test.out.js"

    output = shell_output("#{bin}swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end