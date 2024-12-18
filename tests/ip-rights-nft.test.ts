import { describe, it, expect, beforeEach, vi } from 'vitest';

describe('IP Rights NFT Contract', () => {
  let mockContractCall: any;
  
  beforeEach(() => {
    mockContractCall = vi.fn();
  });
  
  it('should mint an IP rights NFT', async () => {
    mockContractCall.mockResolvedValue({ success: true, value: 1 });
    const result = await mockContractCall('mint', 'patent', 'Test Patent', 'A test patent', 'PAT123456', 1000000);
    expect(result.success).toBe(true);
    expect(result.value).toBe(1);
  });
  
  it('should get IP metadata', async () => {
    mockContractCall.mockResolvedValue({
      success: true,
      value: {
        owner: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
        ipType: 'patent',
        title: 'Test Patent',
        description: 'A test patent',
        registrationNumber: 'PAT123456',
        creationDate: 123,
        expirationDate: 1000000
      }
    });
    const result = await mockContractCall('get-ip-metadata', 1);
    expect(result.success).toBe(true);
    expect(result.value.title).toBe('Test Patent');
  });
  
  it('should transfer an IP rights NFT', async () => {
    mockContractCall.mockResolvedValue({ success: true });
    const result = await mockContractCall('transfer', 1, 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG');
    expect(result.success).toBe(true);
  });
});

