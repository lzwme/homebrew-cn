class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https:shopify.github.ioruby-lsp"
  url "https:github.comShopifyruby-lsparchiverefstagsv0.24.1.tar.gz"
  sha256 "726928a197a35aff4bffb70e459973b7192a2720fbed112b9aaa2916cd5d624f"
  license "MIT"
  head "https:github.comShopifyruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a5612e33bbb5ebe64b5480d8212fa042a775516dc853d8108df3f3ef5462f8e"
    sha256 cellar: :any,                 arm64_sonoma:  "67303313bb8db857fcb1aac091e3bc3f28277420daaf971344cfc2f2814ec77b"
    sha256 cellar: :any,                 arm64_ventura: "808f540e70be843c9f120a7f787bfcde3fd76013d082a3af0d6f6d56e7e428c5"
    sha256 cellar: :any,                 sonoma:        "54368f3d6c63feeee0e7195c09ebbed8111ede43c9d2429e14abb680d0ab3683"
    sha256 cellar: :any,                 ventura:       "f9d28bd7abfa9e8a7e25507fecc3613204025dc5447f0af22c80d9ae344f3b05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07e2b77b332d31f8b9468c5a39f30128ec844612862f0f1ce59730677077c30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "711ca1ddd9b2619664f4b712219694b3d8e8bc4d876aa974f4a39b5710fb2c56"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec"bin#{name}"
    bin.env_script_all_files libexec"bin",
      PATH:     "#{Formula["ruby"].opt_bin}:$PATH",
      GEM_HOME: ENV["GEM_HOME"]
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}ruby-lsp 2>&1", input, 0)
    assert_match(^Content-Length: \d+i, output)
  end
end